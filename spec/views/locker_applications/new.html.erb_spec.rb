# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_applications/new', type: :view do
  let(:user) { FactoryBot.create :user }
  before(:each) do
    sign_in user
    assign(:locker_application, LockerApplication.new(
                                  preferred_size: 1,
                                  preferred_general_area: 'area',
                                  accessible: false,
                                  semester: 'Fall',
                                  status_at_application: 'junior',
                                  department_at_application: 'department',
                                  user: user
                                ))
  end

  it 'renders new locker_application form' do
    render

    assert_select 'form[action=?][method=?]', locker_applications_path, 'post' do
      assert_select 'input-select[name=?]', 'locker_application[preferred_size]', value: '1'

      assert_select 'input-select[name=?]', 'locker_application[preferred_general_area]', value: 'area'

      assert_select 'input[type="checkbox"][name=?]', 'locker_application[accessible]', value: false

      assert_select 'input-select[name=?]', 'locker_application[semester]', value: 'Fall'

      assert_select 'input-select[name=?]', 'locker_application[status_at_application]', value: 'junior'

      assert_select 'input-text[name=?]', 'locker_application[department_at_application]', value: 'department'

      assert_select 'input[type=hidden][name=?]', 'locker_application[user_uid]'
    end
  end

  context 'with an administrative user' do
    let(:user) { FactoryBot.create :user, :admin }

    it 'renders new locker_application form and allows the user netid to be edited' do
      render

      assert_select 'form[action=?][method=?]', locker_applications_path, 'post' do
        assert_select 'input-select[name=?]', 'locker_application[preferred_size]', value: '1'

        assert_select 'input-select[name=?]', 'locker_application[preferred_general_area]', value: 'area'

        assert_select 'input[type="checkbox"][name=?]', 'locker_application[accessible]', value: false

        assert_select 'input-select[name=?]', 'locker_application[semester]', value: 'Fall'

        assert_select 'input-select[name=?]', 'locker_application[status_at_application]', value: 'junior'

        assert_select 'input-text[name=?]', 'locker_application[department_at_application]', value: 'department'

        assert_select 'input[type=hidden][name=?]', 'locker_application[user_uid]', count: 0

        assert_select 'input-text[name=?]', 'locker_application[user_uid]', value: user.uid
      end
    end
  end
end
