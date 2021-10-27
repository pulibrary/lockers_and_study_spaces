# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_applications/new', type: :view do
  before(:each) do
    assign(:locker_application, LockerApplication.new(
                                  preferred_size: 1,
                                  preferred_general_area: 'MyString',
                                  accessible: false,
                                  semester: 'MyString',
                                  staus_at_application: 'MyString',
                                  department_at_application: 'MyString',
                                  user: nil
                                ))
  end

  it 'renders new locker_application form' do
    render

    assert_select 'form[action=?][method=?]', locker_applications_path, 'post' do
      assert_select 'input[name=?]', 'locker_application[preferred_size]'

      assert_select 'input[name=?]', 'locker_application[preferred_general_area]'

      assert_select 'input[name=?]', 'locker_application[accessible]'

      assert_select 'input[name=?]', 'locker_application[semester]'

      assert_select 'input[name=?]', 'locker_application[staus_at_application]'

      assert_select 'input[name=?]', 'locker_application[department_at_application]'

      assert_select 'input[name=?]', 'locker_application[user_id]'
    end
  end
end
