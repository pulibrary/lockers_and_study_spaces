# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ldap, type: :model do
  let(:ldap_connection) { Net::LDAP.new }
  # rubocop:disable Layout/LineLength
  let(:valid_ldap_response) do
    [{ dn: ['uid=abc123,o=princeton university,c=us'], telephonenumber: ['111-222-3333'], edupersonaffiliation: %w[member staff employee], puhomedepartmentnumber: ['99999'], sn: ['Smith'],
       objectclass: %w[inetorgperson organizationalPerson person top puPerson nsMessagingServerUser inetUser ipUser inetMailUser inetLocalMailRecipient nManagedPerson userPresenceProfile oblixorgperson oblixPersonPwdPolicy eduPerson posixAccount],
       givenname: ['Sally'], uid: ['abc123'], displayname: ['Sally Smith'], ou: ['Library Information Technology'], pudisplayname: ['Smith, Sally'], edupersonprincipalname: ['abc123@princeton.edu'], pustatus: ['stf'], edupersonprimaryaffiliation: ['staff'], cn: ['Sally Smith'], universityid: ['999999999'],
       loginshell: ['/bin/no login'], mail: ['sally.smith@princeton.edu'], edupersonentitlement: ['urn:mace:dir:entitlement:common-lib-terms'], puinterofficeaddress: ['Firestone Library$Library Information Technology'], title: ['Staff, Library - Information Technology.'], street: ['B-1H-1 Firestone Library'] }]
  end
  # rubocop:enable Layout/LineLength

  before do
    allow(Ldap).to receive(:default_connection).and_return(ldap_connection)
  end

  context 'with a working ldap connection' do
    let(:expected_attributes) do
      { netid: 'abc123', department: 'Library Information Technology', status: 'staff', pustatus: 'stf',
        universityid: '999999999', class_year: nil, email: 'sally.smith@princeton.edu', name: 'Sally Smith' }
    end

    describe '#find_by_email' do
      before do
        allow(ldap_connection).to receive(:search).with(filter: Net::LDAP::Filter.eq('mail', 'abc123@princeton.edu')).and_return(valid_ldap_response)
      end

      it 'returns a users attributes' do
        expect(described_class.find_by_email('abc123')).to eq(expected_attributes)
      end
    end

    describe '#find_by_netid' do
      before do
        allow(ldap_connection).to receive(:search).with(filter: Net::LDAP::Filter.eq('uid', 'abc123')).and_return(valid_ldap_response)
      end

      it 'returns a users attributes' do
        expect(described_class.find_by_netid('abc123')).to eq(expected_attributes)
      end
    end
  end

  context 'with an ldap error' do
    describe '#find_by_email' do
      before do
        allow(ldap_connection).to receive(:search).with(filter: Net::LDAP::Filter.eq('mail', 'abc123@princeton.edu')).and_raise(Net::LDAP::Error)
      end

      it 'retries the search and logs to the rails log' do
        allow(Rails.logger).to receive(:warn)
        described_class.find_by_email('abc123')
        expect(Rails.logger).to have_received(:warn).exactly(4).times
      end
    end

    describe '#find_by_netid' do
      before do
        allow(ldap_connection).to receive(:search).with(filter: Net::LDAP::Filter.eq('uid', 'abc123')).and_raise(Net::LDAP::Error)
      end

      it 'retries the search and logs to the rails log' do
        allow(Rails.logger).to receive(:warn)
        described_class.find_by_netid('abc123')
        expect(Rails.logger).to have_received(:warn).exactly(4).times
      end
    end
  end
end
