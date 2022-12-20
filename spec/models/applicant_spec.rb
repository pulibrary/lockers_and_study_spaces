# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Layout/LineLength
RSpec.describe Applicant do
  subject(:applicant) { described_class.new(user) }

  let(:current_academic_year) do
    now = DateTime.now
    year = now.year
    year += 1 if now.month > 6
    year
  end
  let(:user) { FactoryBot.create(:user, uid: 'abc123') }
  let(:ldap_connection) { Net::LDAP.new }
  let(:valid_ldap_response) do
    [{ dn: ['uid=abc123,o=princeton university,c=us'], telephonenumber: ['111-222-3333'], edupersonaffiliation: %w[member staff employee], puhomedepartmentnumber: ['99999'], sn: ['Smith'],
       objectclass: %w[inetorgperson organizationalPerson person top puPerson nsMessagingServerUser inetUser ipUser inetMailUser inetLocalMailRecipient nManagedPerson userPresenceProfile oblixorgperson oblixPersonPwdPolicy eduPerson posixAccount],
       givenname: ['Sally'], uid: ['abc123'], displayname: ['Sally Smith'], ou: ['Library Information Technology'], pudisplayname: ['Smith, Sally'], edupersonprincipalname: ['abc123@princeton.edu'], pustatus: ['stf'], edupersonprimaryaffiliation: ['staff'], cn: ['Sally Smith'], universityid: ['999999999'],
       loginshell: ['/bin/no login'], mail: ['sally.smith@princeton.edu'], edupersonentitlement: ['urn:mace:dir:entitlement:common-lib-terms'], puinterofficeaddress: ['Firestone Library$Library Information Technology'], title: ['Staff, Library - Information Technology.'], street: ['B-1H-1 Firestone Library'] }]
  end

  before do
    allow(Ldap).to receive(:default_connection).and_return(ldap_connection)
    allow(ldap_connection).to receive(:search).with(filter: Net::LDAP::Filter.eq('uid', 'abc123')).and_return(valid_ldap_response)
  end

  it 'looks up ldap on initialization' do
    expect(applicant.ldap).to eq(class_year: nil, department: 'Library Information Technology', email: 'sally.smith@princeton.edu',
                                 netid: 'abc123', pustatus: 'stf', status: 'staff', universityid: '999999999', name: 'Sally Smith')
  end

  it 'is not a senior' do
    expect(applicant).not_to be_senior
  end

  it 'is not a junior' do
    expect(applicant).not_to be_junior
  end

  it 'is staff' do
    expect(applicant).to be_staff
  end

  it 'is not a graduate student' do
    expect(applicant).not_to be_graduate_student
  end

  context 'a student graduating this year' do
    let(:valid_ldap_response) do
      [{ dn: ['uid=abc123,o=princeton university,c=us'], telephonenumber: ['111-222-3333'], edupersonaffiliation: %w[member staff employee], puhomedepartmentnumber: ['99999'], sn: ['Smith'],
         objectclass: %w[inetorgperson organizationalPerson person top puPerson nsMessagingServerUser inetUser ipUser inetMailUser inetLocalMailRecipient nManagedPerson userPresenceProfile oblixorgperson oblixPersonPwdPolicy eduPerson posixAccount],
         givenname: ['Sally'], uid: ['abc123'], displayname: ['Sally Smith'], ou: ['Library Information Technology'], pudisplayname: ['Smith, Sally'], edupersonprincipalname: ['abc123@princeton.edu'], pustatus: ['undergraduate'], edupersonprimaryaffiliation: ['staff'], cn: ['Sally Smith'], universityid: ['999999999'],
         loginshell: ['/bin/no login'], mail: ['sally.smith@princeton.edu'], edupersonentitlement: ['urn:mace:dir:entitlement:common-lib-terms'], puinterofficeaddress: ['Firestone Library$Library Information Technology'], title: ['Staff, Library - Information Technology.'], street: ['B-1H-1 Firestone Library'],
         puclassyear: [current_academic_year.to_s] }]
    end

    it 'is a senior' do
      expect(applicant).to be_senior
    end

    it 'is not a junior' do
      expect(applicant).not_to be_junior
    end

    it 'is not staff' do
      expect(applicant).not_to be_staff
    end

    it 'is not a graduate student' do
      expect(applicant).not_to be_graduate_student
    end
  end

  context 'a student graduating next academic year' do
    let(:valid_ldap_response) do
      [{ dn: ['uid=abc123,o=princeton university,c=us'], telephonenumber: ['111-222-3333'], edupersonaffiliation: %w[member staff employee], puhomedepartmentnumber: ['99999'], sn: ['Smith'],
         objectclass: %w[inetorgperson organizationalPerson person top puPerson nsMessagingServerUser inetUser ipUser inetMailUser inetLocalMailRecipient nManagedPerson userPresenceProfile oblixorgperson oblixPersonPwdPolicy eduPerson posixAccount],
         givenname: ['Sally'], uid: ['abc123'], displayname: ['Sally Smith'], ou: ['Library Information Technology'], pudisplayname: ['Smith, Sally'], edupersonprincipalname: ['abc123@princeton.edu'], pustatus: ['undergraduate'], edupersonprimaryaffiliation: ['staff'], cn: ['Sally Smith'], universityid: ['999999999'],
         loginshell: ['/bin/no login'], mail: ['sally.smith@princeton.edu'], edupersonentitlement: ['urn:mace:dir:entitlement:common-lib-terms'], puinterofficeaddress: ['Firestone Library$Library Information Technology'], title: ['Staff, Library - Information Technology.'], street: ['B-1H-1 Firestone Library'],
         puclassyear: [(current_academic_year + 1).to_s] }]
    end

    it 'is not a senior' do
      expect(applicant).not_to be_senior
    end

    it 'is a junior' do
      expect(applicant).to be_junior
    end

    it 'is not staff' do
      expect(applicant).not_to be_staff
    end

    it 'is not a graduate student' do
      expect(applicant).not_to be_graduate_student
    end
  end

  context 'a graduate student' do
    let(:valid_ldap_response) do
      [{ dn: ['uid=abc123,o=princeton university,c=us'], telephonenumber: ['111-222-3333'], edupersonaffiliation: %w[member staff employee], puhomedepartmentnumber: ['99999'], sn: ['Smith'],
         objectclass: %w[inetorgperson organizationalPerson person top puPerson nsMessagingServerUser inetUser ipUser inetMailUser inetLocalMailRecipient nManagedPerson userPresenceProfile oblixorgperson oblixPersonPwdPolicy eduPerson posixAccount],
         givenname: ['Sally'], uid: ['abc123'], displayname: ['Sally Smith'], ou: ['Library Information Technology'], pudisplayname: ['Smith, Sally'], edupersonprincipalname: ['abc123@princeton.edu'], pustatus: ['graduate'], edupersonprimaryaffiliation: ['staff'], cn: ['Sally Smith'], universityid: ['999999999'],
         loginshell: ['/bin/no login'], mail: ['sally.smith@princeton.edu'], edupersonentitlement: ['urn:mace:dir:entitlement:common-lib-terms'], puinterofficeaddress: ['Firestone Library$Library Information Technology'], title: ['Staff, Library - Information Technology.'], street: ['B-1H-1 Firestone Library'] }]
    end

    it 'is not a senior' do
      expect(applicant).not_to be_senior
    end

    it 'is not a junior' do
      expect(applicant).not_to be_junior
    end

    it 'is not staff' do
      expect(applicant).not_to be_staff
    end

    it 'is a graduate student' do
      expect(applicant).to be_graduate_student
    end
  end
end
# rubocop:enable Layout/LineLength
