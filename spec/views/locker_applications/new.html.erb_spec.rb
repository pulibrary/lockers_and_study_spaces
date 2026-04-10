# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_applications/new' do
  let(:user) { FactoryBot.create(:user) }
  let(:building) { FactoryBot.create(:building) }

  before do
    sign_in user
    building
    assign(:locker_application, LockerApplication.new(
                                  preferred_size: 1,
                                  preferred_general_area: 'area',
                                  accessible: false,
                                  semester: 'Fall',
                                  status_at_application: 'junior',
                                  department_at_application: 'department',
                                  user:,
                                  building:
                                ))
  end

  it 'renders new locker_application form' do
    render

    assert_select 'form[action=?][method=?]', locker_applications_path, 'post' do
      assert_select 'input[type=hidden][name=?]', 'locker_application[user_uid]'
    end
  end

  context 'with an administrative user' do
    let(:user) { FactoryBot.create(:user, :admin) }

    it 'renders new locker_application form and allows the user netid to be edited' do
      render

      assert_select 'lux-input-text[name=?]', 'locker_application[user_uid]', count: 1
    end
  end
end
