# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/locker_applications', type: :request do
  let(:user) { FactoryBot.create :user }
  # LockerApplication. As you add validations to LockerApplication, be sure to
  # adjust the attributes here as well.

  let(:valid_attributes) do
    {
      building_id: building_one.id,
      preferred_size: 2,
      preferred_general_area: 'Preferred General Area',
      accessible: false,
      semester: 'Semester',
      status_at_application: 'Status At Application',
      department_at_application: 'Department At Application',
      user_id: user.id,
      complete: true
    }
  end
  let(:valid_form_attributes) do
    {
      building_id: building_one.id,
      preferred_size: 2,
      preferred_general_area: 'Preferred General Area',
      accessible: false,
      semester: 'Semester',
      status_at_application: 'Status At Application',
      department_at_application: 'Department At Application',
      user_uid: user.uid
    }
  end
  let(:invalid_attributes) do
    {
      preferred_size: 2,
      preferred_general_area: 'Preferred General Area',
      accessible: false,
      semester: 'Semester',
      status_at_application: 'Status At Application',
      department_at_application: 'Department At Application',
      user_id: nil
    }
  end
  let(:invalid_form_attributes) do
    {
      preferred_size: 2,
      preferred_general_area: 'Preferred General Area',
      accessible: false,
      semester: 'Semester',
      status_at_application: 'Status At Application',
      department_at_application: 'Department At Application',
      user_uid: nil
    }
  end
  let(:building_one) { FactoryBot.create(:building) }
  let(:building_two) { FactoryBot.create(:building, name: 'Lewis Library') }

  before do
    building_one
    building_two
    sign_in user
  end

  describe 'GET /index' do
    it 'redirects to root' do
      LockerApplication.create! valid_attributes
      get locker_applications_url
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET /show' do
    it 'Shows the user their application' do
      locker_application = LockerApplication.create! valid_attributes
      get locker_application_url(locker_application)
      expect(response).to be_successful
    end

    context "another's application" do
      before do
        valid_attributes[:user_id] = FactoryBot.create(:user).id
      end

      it 'redirects to root' do
        locker_application = LockerApplication.create! valid_attributes
        get locker_application_url(locker_application)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET /new' do
    it 'allows a user to apply for a locker' do
      get new_locker_application_url
      expect(response).to be_successful
    end
  end

  describe 'GET /assign' do
    it 'redirects to root' do
      locker_application = LockerApplication.create! valid_attributes
      get assign_locker_application_url(locker_application)
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET /edit' do
    context 'with a complete application' do
      it 'redirects to root' do
        locker_application = LockerApplication.create! valid_attributes
        get edit_locker_application_url(locker_application)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with an incomplete application' do
      let(:valid_attributes) do
        {
          building_id: building_one.id,
          preferred_size: 2,
          preferred_general_area: 'Preferred General Area',
          accessible: false,
          semester: 'Semester',
          status_at_application: 'Status At Application',
          department_at_application: 'Department At Application',
          user_id: user.id,
          complete: false
        }
      end

      it 'allows the user to edit' do
        locker_application = LockerApplication.create! valid_attributes
        get edit_locker_application_url(locker_application)
        expect(response).to be_successful
      end
    end
  end

  describe 'POST /create' do
    context 'with lewis_patrons on' do
      let(:valid_form_attributes) do
        {
          building_id: building_one.id,
          user_uid: user.uid
        }
      end

      before do
        allow(Flipflop).to receive(:lewis_patrons?).and_return(true)
      end

      context 'creates an application for the user' do
        it 'creates a locker application' do
          expect do
            post locker_applications_url, params: { locker_application: valid_form_attributes }
          end.to change(LockerApplication, :count).by(1)
        end

        it 'brings the user to the second step of the locker application' do
          post locker_applications_url, params: { locker_application: valid_form_attributes }
          expect(response).to redirect_to(edit_locker_application_url(LockerApplication.last))
        end

        context "another's application" do
          before do
            valid_form_attributes[:user_uid] = FactoryBot.create(:user).uid
          end

          it 'redirects to root' do
            expect do
              post locker_applications_url, params: { locker_application: valid_form_attributes }
            end.not_to change(LockerApplication, :count)
            expect(response).to redirect_to(root_path)
          end
        end
      end

      context 'with missing building parameter' do
        let(:invalid_form_attributes) do
          {
            building_id: nil,
            preferred_size: 2,
            preferred_general_area: 'Preferred General Area',
            accessible: false,
            semester: 'Semester',
            status_at_application: 'Status At Application',
            department_at_application: 'Department At Application',
            user_uid: user.uid
          }
        end

        it 'does not create a new locker application' do
          expect do
            post locker_applications_url, params: { locker_application: invalid_form_attributes }
          end.not_to change(LockerApplication, :count)
        end

        it 'takes the user back to the new form' do
          post locker_applications_url, params: { locker_application: invalid_form_attributes }
          expect(response).to be_unprocessable
          expect(response).to render_template(:new)
        end
      end
    end

    context 'with lewis_patrons off' do
      before do
        allow(Flipflop).to receive(:lewis_patrons?).and_return(false)
      end

      context 'creates an application for the user' do
        it 'creates a new locker application' do
          expect do
            post locker_applications_url, params: { locker_application: valid_form_attributes }
          end.to change(LockerApplication, :count).by(1)
        end

        it 'Shows the user their application' do
          post locker_applications_url, params: { locker_application: valid_form_attributes }
          expect(response).to redirect_to(locker_application_url(LockerApplication.last))
        end

        context "another's application" do
          before do
            valid_form_attributes[:user_uid] = FactoryBot.create(:user).uid
          end

          it 'redirects to root' do
            expect do
              post locker_applications_url, params: { locker_application: valid_form_attributes }
            end.not_to change(LockerApplication, :count)
            expect(response).to redirect_to(root_path)
          end
        end
      end

      context 'with invalid parameters' do
        it 'redirects to root' do
          expect do
            post locker_applications_url, params: { locker_application: invalid_form_attributes }
          end.not_to change(LockerApplication, :count)
          expect(response).to redirect_to(root_path)
        end

        it 'redirects to root' do
          post locker_applications_url, params: { locker_application: invalid_form_attributes }
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          preferred_size: 4,
          preferred_general_area: 'Preferred General Area two',
          accessible: false,
          semester: 'Semester',
          status_at_application: 'Status At Application',
          department_at_application: 'Department At Application',
          user_uid: user.uid
        }
      end

      it 'redirects to root and does not update the data' do
        locker_application = LockerApplication.create! valid_attributes
        patch locker_application_url(locker_application), params: { locker_application: new_attributes }
        locker_application.reload
        expect(locker_application.preferred_size).to eq(2)
        expect(locker_application.preferred_general_area).to eq('Preferred General Area')
      end

      it 'redirects to root' do
        locker_application = LockerApplication.create! valid_attributes
        patch locker_application_url(locker_application), params: { locker_application: new_attributes }
        locker_application.reload
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid parameters' do
      it 'redirects to root' do
        locker_application = LockerApplication.create! valid_attributes
        patch locker_application_url(locker_application), params: { locker_application: invalid_form_attributes }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'redirects to root' do
      locker_application = LockerApplication.create! valid_attributes
      expect do
        delete locker_application_url(locker_application)
      end.not_to change(LockerApplication, :count)
      expect(response).to redirect_to(root_path)
    end

    it 'redirects to root' do
      locker_application = LockerApplication.create! valid_attributes
      delete locker_application_url(locker_application)
      expect(response).to redirect_to(root_path)
    end
  end

  context 'with an admin user' do
    let(:user) { FactoryBot.create :user, :admin }

    describe 'GET /index' do
      it 'renders a successful response' do
        LockerApplication.create! valid_attributes
        get locker_applications_url
        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders a successful response' do
        locker_application = LockerApplication.create! valid_attributes
        get locker_application_url(locker_application)
        expect(response).to be_successful
      end
    end

    describe 'GET /new' do
      it 'renders a successful response' do
        get new_locker_application_url
        expect(response).to be_successful
      end
    end

    describe 'GET /edit' do
      it 'render a successful response' do
        locker_application = LockerApplication.create! valid_attributes
        get edit_locker_application_url(locker_application)
        expect(response).to be_successful
      end
    end

    describe 'POST /create' do
      context 'with valid parameters' do
        it 'creates a new LockerApplication' do
          expect do
            post locker_applications_url, params: { locker_application: valid_form_attributes }
          end.to change(LockerApplication, :count).by(1)
        end

        it 'redirects to the created locker_application' do
          post locker_applications_url, params: { locker_application: valid_form_attributes }
          expect(response).to redirect_to(locker_application_url(LockerApplication.last))
        end
      end

      context "another's application with valid parameters" do
        before do
          valid_form_attributes[:user_uid] = FactoryBot.create(:user).uid
        end

        context 'with a regular user' do
          let(:user) { FactoryBot.create(:user, admin: false) }

          it 'does not create a new LockerApplication' do
            expect(user.admin?).to be(false)
            expect do
              post locker_applications_url, params: { locker_application: valid_form_attributes }
            end.not_to change(LockerApplication, :count)
          end
        end

        context 'with an admin' do
          let(:admin) { FactoryBot.create(:user, admin: true) }

          before do
            sign_in admin
          end

          it 'creates a new LockerApplication' do
            expect do
              post locker_applications_url, params: { locker_application: valid_form_attributes }
            end.to change(LockerApplication, :count).by(1)
          end
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new LockerApplication' do
          expect do
            post locker_applications_url, params: { locker_application: invalid_form_attributes }
          end.not_to change(LockerApplication, :count)
        end

        it "renders a successful response (i.e. to display the 'new' template)" do
          post locker_applications_url, params: { locker_application: invalid_form_attributes }
          expect(response).to be_unprocessable
          expect(response).to render_template(:new)
        end
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:new_attributes) do
          {
            preferred_size: 4,
            preferred_general_area: 'Preferred General Area Two',
            accessible: false,
            semester: 'Semester',
            status_at_application: 'Status At Application',
            department_at_application: 'Department At Application',
            user_uid: user.uid
          }
        end

        it 'updates the requested locker_application' do
          locker_application = LockerApplication.create! valid_attributes
          patch locker_application_url(locker_application), params: { locker_application: new_attributes }
          locker_application.reload
          expect(locker_application.preferred_size).to eq(4)
          expect(locker_application.preferred_general_area).to eq('Preferred General Area Two')
        end

        it 'redirects to the locker_application' do
          locker_application = LockerApplication.create! valid_attributes
          patch locker_application_url(locker_application), params: { locker_application: new_attributes }
          locker_application.reload
          expect(response).to redirect_to(locker_application_url(locker_application))
        end
      end

      context 'with invalid parameters' do
        it "renders a successful response (i.e. to display the 'edit' template)" do
          locker_application = LockerApplication.create! valid_attributes
          patch locker_application_url(locker_application), params: { locker_application: invalid_form_attributes }
          expect(response).to be_unprocessable
          expect(response).to render_template(:edit)
        end
      end
    end

    describe 'DELETE /destroy' do
      it 'destroys the requested locker_application' do
        locker_application = LockerApplication.create! valid_attributes
        expect do
          delete locker_application_url(locker_application)
        end.to change(LockerApplication, :count).by(-1)
      end

      it 'redirects to the locker_applications list' do
        locker_application = LockerApplication.create! valid_attributes
        delete locker_application_url(locker_application)
        expect(response).to redirect_to(locker_applications_url)
      end
    end

    describe 'GET /assign' do
      it 'allows an admin to assign a locker' do
        locker_application = LockerApplication.create! valid_attributes
        get assign_locker_application_url(locker_application)
        expect(response).to be_successful
      end
    end

    describe 'GET /awaiting_assignment' do
      it 'allows an admin to assign a locker' do
        LockerApplication.create! valid_attributes
        get awaiting_assignment_locker_applications_url
        expect(response).to be_successful
      end
    end
  end
end
