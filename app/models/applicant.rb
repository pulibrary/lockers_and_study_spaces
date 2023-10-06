# frozen_string_literal: true

class Applicant
  attr_reader :user, :ldap

  def initialize(user, ldap: Ldap.find_by_netid(user.uid))
    @user = user
    @ldap = ldap
  end

  def senior?
    undergraduate? && current_academic_year == class_year
  end

  def junior?
    undergraduate? && current_academic_year + 1 == class_year
  end

  def undergraduate?
    ldap[:pustatus] == 'undergraduate'
  end

  def staff?
    ldap[:pustatus] == 'stf'
  end

  def graduate_student?
    ldap[:pustatus] == 'graduate'
  end

  def department
    ldap[:department]
  end

  def email
    email = ldap[:email] || "#{user.uid}@princeton.edu"
    email.gsub('@@', '@')
  end

  def name
    ldap[:name] || user.uid
  end

  def to_s
    user.uid
  end

  def status
    if senior?
      'senior'
    elsif junior?
      'junior'
    else
      ldap[:status]
    end
  end

  private

  def class_year
    ldap[:class_year].to_i
  end

  def current_academic_year
    # After June we are in the next year Aka July 2021, would be Academic Year 2022
    now = DateTime.now
    if now.month > 6
      now.year + 1
    else
      now.year
    end
  end
end
