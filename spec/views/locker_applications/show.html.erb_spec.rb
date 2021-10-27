# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'locker_applications/show', type: :view do
  let(:user) { FactoryBot.create :user }
  before(:each) do
    @locker_application = assign(:locker_application, LockerApplication.create!(
                                                        preferred_size: 2,
                                                        preferred_general_area: 'Preferred General Area',
                                                        accessible: false,
                                                        semester: 'Semester',
                                                        staus_at_application: 'Staus At Application',
                                                        department_at_application: 'Department At Application',
                                                        user: user
                                                      ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Preferred General Area/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Semester/)
    expect(rendered).to match(/Staus At Application/)
    expect(rendered).to match(/Department At Application/)
    expect(rendered).to match(/#{user.uid}/)
  end
end
