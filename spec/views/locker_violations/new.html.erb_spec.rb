# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_violations/new', type: :view do
  before do
    assign(:locker_violation, FactoryBot.build(:locker_violation))
  end

  it 'renders new violation form' do
    render

    assert_select 'form[action=?][method=?]', locker_violations_path, 'post' do
      assert_select 'input[type=hidden][name=?]', 'locker_violation[user_id]', count: 0
      assert_select 'input[type=hidden][name=?]', 'locker_violation[locker_id]', count: 0
      assert_select 'input-text[name=?]', 'locker_violation[number_of_books]', count: 0
      expect(rendered).to match(/There is no user currently assigned to the locker!/)
    end
  end
end
