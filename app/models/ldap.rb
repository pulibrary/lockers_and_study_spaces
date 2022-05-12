# frozen_string_literal: true

require 'net/ldap'

class Ldap
  class << self
    def find_by_netid(net_id, ldap_connection: default_connection)
      attempts ||= 1

      filter = Net::LDAP::Filter.eq('uid', net_id)
      result = ldap_connection.search(filter: filter).first
      return {} if result.blank?

      attributes(result)
    rescue Net::LDAP::Error => e
      if (attempts += 1) < 5 # go back to begin block if condition ok
        Rails.logger.warn("LDAP error from find_by_netid: #{e}, re-trying")
        retry
      end
      Rails.logger.warn('Retry attempts exceeded. Moving on.')
    end

    # rubocop:disable Metrics/AbcSize
    def find_by_email(email, ldap_connection: default_connection)
      attempts ||= 1

      email = clean_email(email)
      filter = Net::LDAP::Filter.eq('mail', email)
      result = ldap_connection.search(filter: filter).first
      if result.blank?
        filter = Net::LDAP::Filter.eq('edupersonprincipalname', email)
        result = ldap_connection.search(filter: filter).first
      end
      return find_by_netid(email.split('@').first, ldap_connection: ldap_connection) if result.blank?

      attributes(result)
    rescue Net::LDAP::Error => e
      if (attempts += 1) < 5 # go back to begin block if condition ok
        Rails.logger.warn("LDAP error from find_by_email: #{e}, re-trying")
        retry
      end
      Rails.logger.warn('Retry attempts exceeded. Moving on.')
    end
    # rubocop:enable Metrics/AbcSize

    private

    # rubocop:disable Metrics/CyclomaticComplexity
    def attributes(result)
      {
        netid: result[:uid]&.first,
        department: department(result),
        status: result[:edupersonprimaryaffiliation]&.first,
        pustatus: result[:pustatus]&.first,
        universityid: result[:universityid]&.first,
        class_year: result[:puclassyear]&.first,
        email: result[:mail]&.first,
        name: result[:displayname]&.first
      }
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    def department(result)
      result[:purescollege]&.first || result[:ou]&.first
    end

    def clean_email(email)
      email = "#{email}@princeton.edu" unless email.include?('@')
      email = "#{email}princeton.edu" if email.ends_with?('@')
      email
    end

    def default_connection
      @default_connection ||= Net::LDAP.new host: 'ldap.princeton.edu', base: 'o=Princeton University,c=US', port: 636,
                                            encryption: {
                                              method: :simple_tls,
                                              tls_options: OpenSSL::SSL::SSLContext::DEFAULT_PARAMS
                                            }
    end

    def find_eqaul(field, value)
      filter = Net::LDAP::Filter.eq(field, value)
      ldap_connection.search(filter: filter).first
    end
  end
end
