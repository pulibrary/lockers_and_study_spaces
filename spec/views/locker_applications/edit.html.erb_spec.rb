# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_applications/edit' do
  let(:user) { FactoryBot.create(:user) }
  let(:building_one) { FactoryBot.create(:building, id: 1) }
  let(:building_two) { FactoryBot.create(:building, id: 2, name: 'Lewis Library') }

  before do
    building_one
    building_two
    sign_in user
    @locker_application = assign(:locker_application, LockerApplication.create!(
                                                        preferred_size: 1,
                                                        preferred_general_area: 'MyString',
                                                        accessible: false,
                                                        semester: 'MyString',
                                                        status_at_application: 'MyString',
                                                        department_at_application: 'MyString',
                                                        user:
                                                      ))
  end

  it 'renders the edit locker_application form' do
    render

    assert_select 'form[action=?][method=?]', locker_application_path(@locker_application), 'post' do
      assert_select 'lux-input-select[name=?]', 'locker_application[preferred_size]'

      assert_select 'lux-input-select[name=?]', 'locker_application[preferred_general_area]'

      assert_select 'input[type="checkbox"][name=?]', 'locker_application[accessibility_needs][]'

      assert_select 'lux-input-select[name=?]', 'locker_application[semester]'

      assert_select 'lux-input-select[name=?]', 'locker_application[status_at_application]'

      assert_select 'input-text[name=?]', 'locker_application[department_at_application]'

      assert_select 'input[type=hidden][name=?]', 'locker_application[user_uid]'
    end
  end

  it 'limits the length of the department field to 70' do
    render
    assert_select '#locker_application_department_at_application[maxlength="70"]'
  end

  context 'with an administrative user' do
    let(:user) { FactoryBot.create(:user, :admin) }

    it 'renders the edit locker_application form and allows the user netid to be edited' do
      render

      assert_select 'form[action=?][method=?]', locker_application_path(@locker_application), 'post' do
        assert_select 'lux-input-select[name=?]', 'locker_application[preferred_size]'

        assert_select 'lux-input-select[name=?]', 'locker_application[preferred_general_area]'

        assert_select 'input[type="checkbox"][name=?]', 'locker_application[accessibility_needs][]'

        assert_select 'lux-input-select[name=?]', 'locker_application[semester]'

        assert_select 'lux-input-select[name=?]', 'locker_application[status_at_application]'

        assert_select 'input-text[name=?]', 'locker_application[department_at_application]'

        assert_select 'input[type=hidden][name=?]', 'locker_application[user_uid]', count: 0
        assert_select 'input-text[name=?]', 'locker_application[user_uid]'
      end
    end
  end
end
