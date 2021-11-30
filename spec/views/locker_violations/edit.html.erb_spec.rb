# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_violations/edit', type: :view do
  before(:each) do
    @locker_violation = assign(:locker_violation, FactoryBot.create(:locker_violation))
  end

  it 'renders the edit violation form' do
    render
    assert_select 'form[action=?][method=?]', locker_violation_path(@locker_violation), 'post' do
      assert_select 'input[type=hidden][name=?]', 'locker_violation[user_id]', count: 0
      assert_select 'input[type=hidden][name=?]', 'locker_violation[locker_id]', count: 0
      assert_select 'input-text[name=?]', 'locker_violation[number_of_books]', count: 0
      expect(rendered).to match(/There is no user currently assigned to the locker!/)
    end
  end

  context 'with an assigned user' do
    before do
      application = FactoryBot.create :locker_application, user: @locker_violation.user
      FactoryBot.create :locker_assignment, locker: @locker_violation.locker, locker_application: application
    end
    it 'renders the edit violation form' do
      render
      assert_select 'form[action=?][method=?]', locker_violation_path(@locker_violation), 'post' do
        assert_select 'input[type=hidden][name=?]', 'locker_violation[user_id]'
        assert_select 'input[type=hidden][name=?]', 'locker_violation[locker_id]'
        assert_select 'input-text[name=?]', 'locker_violation[number_of_books]'
        expect(rendered).not_to match(/There is no user currently assigned to the locker!/)
      end
    end
  end
end
