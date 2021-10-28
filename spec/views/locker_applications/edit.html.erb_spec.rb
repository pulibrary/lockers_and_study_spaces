# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_applications/edit', type: :view do
  let(:user) { FactoryBot.create :user }
  before(:each) do
    sign_in user
    @locker_application = assign(:locker_application, LockerApplication.create!(
                                                        preferred_size: 1,
                                                        preferred_general_area: 'MyString',
                                                        accessible: false,
                                                        semester: 'MyString',
                                                        staus_at_application: 'MyString',
                                                        department_at_application: 'MyString',
                                                        user: user
                                                      ))
  end

  it 'renders the edit locker_application form' do
    render

    assert_select 'form[action=?][method=?]', locker_application_path(@locker_application), 'post' do
      assert_select 'select[name=?]', 'locker_application[preferred_size]'

      assert_select 'select[name=?]', 'locker_application[preferred_general_area]'

      assert_select 'input[name=?]', 'locker_application[accessible]'

      assert_select 'select[name=?]', 'locker_application[semester]'

      assert_select 'input[name=?]', 'locker_application[staus_at_application]'

      assert_select 'input[name=?]', 'locker_application[department_at_application]'

      assert_select 'input[type=hidden][name=?]', 'locker_application[user_uid]'
    end
  end

  context 'with an administrative user' do
    let(:user) { FactoryBot.create :user, :admin }

    it 'renders the edit locker_application form and allows the user netid to be edited' do
      render

      assert_select 'form[action=?][method=?]', locker_application_path(@locker_application), 'post' do
        assert_select 'select[name=?]', 'locker_application[preferred_size]'

        assert_select 'select[name=?]', 'locker_application[preferred_general_area]'

        assert_select 'input[name=?]', 'locker_application[accessible]'

        assert_select 'select[name=?]', 'locker_application[semester]'

        assert_select 'input[name=?]', 'locker_application[staus_at_application]'

        assert_select 'input[name=?]', 'locker_application[department_at_application]'

        assert_select 'input[type=hidden][name=?]', 'locker_application[user_uid]', count: 0
        assert_select 'input[name=?]', 'locker_application[user_uid]'
      end
    end
  end
end
