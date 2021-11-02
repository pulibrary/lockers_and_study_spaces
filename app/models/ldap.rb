# frozen_string_literal: true

require 'net/ldap'

class Ldap
  class << self
    def find_by_netid(net_id, ldap_connection: default_connection)
      filter = Net::LDAP::Filter.eq('uid', net_id)
      result = ldap_connection.search(filter: filter).first
      return {} if result.blank?

      attributes(result)
    end

    def find_by_email(email, ldap_connection: default_connection)
      email = clean_email(email)
      filter = Net::LDAP::Filter.eq('mail', email)
      result = ldap_connection.search(filter: filter).first
      if result.blank?
        filter = Net::LDAP::Filter.eq('edupersonprincipalname', email)
        result = ldap_connection.search(filter: filter).first
      end
      return find_by_netid(email.split('@').first, ldap_connection: ldap_connection) if result.blank?

      attributes(result)
    end

    private

    def attributes(result)
      {
        netid: result[:uid]&.first,
        department: department(result),
        status: result[:edupersonprimaryaffiliation]&.first,
        pustatus: result[:pustatus]&.first,
        universityid: result[:universityid]&.first,
        class_year: result[:puclassyear]&.first
      }
    end

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
