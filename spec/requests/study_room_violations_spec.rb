# frozen_string_literal: true

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe '/study_room_violations' do
  let(:user) { FactoryBot.create(:user) }
  # StudyRoomViolation. As you add validations to StudyRoomViolation, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { study_room_id: study_room.id, user_id: violation_user.id, number_of_books: 8 }
  end
  let(:invalid_attributes) do
    { study_room_id: study_room.id, user_id: 123_456, number_of_books: 8 }
  end
  let(:study_room) { FactoryBot.create(:study_room) }
  let(:violation_user) { FactoryBot.create(:user) }
  let(:study_room_assignment) { FactoryBot.create(:study_room_assignment, user: violation_user) }

  before do
    sign_in user
    study_room_assignment
  end

  describe 'GET /index' do
    it 'renders a redirect response' do
      StudyRoomViolation.create! valid_attributes
      get study_room_violations_url
      expect(response).to be_redirect
    end
  end

  describe 'GET /show' do
    it 'renders a redirect response' do
      study_room_violation = StudyRoomViolation.create! valid_attributes
      get study_room_violation_url(study_room_violation)
      expect(response).to be_redirect
    end
  end

  describe 'GET /new' do
    it 'renders a redirect response' do
      get new_study_room_violation_url
      expect(response).to be_redirect
    end
  end

  describe 'GET /edit' do
    it 'render a redirect response' do
      study_room_violation = StudyRoomViolation.create! valid_attributes
      get edit_study_room_violation_url(study_room_violation)
      expect(response).to be_redirect
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new StudyRoomViolation' do
        expect do
          post study_room_violations_url, params: { study_room_violation: valid_attributes }
        end.not_to change(StudyRoomViolation, :count)
      end

      it 'redirects to the created study_room_violation' do
        post study_room_violations_url, params: { study_room_violation: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new StudyRoomViolation' do
        expect do
          post study_room_violations_url, params: { study_room_violation: invalid_attributes }
        end.not_to change(StudyRoomViolation, :count)
      end

      it "renders a redirect response (i.e. to display the 'new' template)" do
        post study_room_violations_url, params: { study_room_violation: invalid_attributes }
        expect(response).to be_redirect
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      it 'updates the requested study_room_violation' do
        study_room_violation = StudyRoomViolation.create! valid_attributes
        patch study_room_violation_url(study_room_violation), params: { study_room_violation: new_attributes }
        study_room_violation.reload
        skip('Add assertions for updated state')
      end

      it 'redirects to the study_room_violation' do
        study_room_violation = StudyRoomViolation.create! valid_attributes
        patch study_room_violation_url(study_room_violation), params: { study_room_violation: new_attributes }
        study_room_violation.reload
        expect(response).to redirect_to(study_room_violation_url(study_room_violation))
      end
    end

    context 'with invalid parameters' do
      it "renders a redirect response (i.e. to display the 'edit' template)" do
        study_room_violation = StudyRoomViolation.create! valid_attributes
        patch study_room_violation_url(study_room_violation), params: { study_room_violation: invalid_attributes }
        expect(response).to be_redirect
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'does not destroy the requested study_room_violation' do
      study_room_violation = StudyRoomViolation.create! valid_attributes
      expect do
        delete study_room_violation_url(study_room_violation)
      end.not_to change(StudyRoomViolation, :count)
    end

    it 'redirects to the root path' do
      study_room_violation = StudyRoomViolation.create! valid_attributes
      delete study_room_violation_url(study_room_violation)
      expect(response).to redirect_to(root_path)
    end
  end

  context 'an admin user' do
    let(:user) { FactoryBot.create(:user, :admin) }

    describe 'GET /index' do
      it 'renders a successful response' do
        StudyRoomViolation.create! valid_attributes
        get study_room_violations_url
        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders a successful response' do
        study_room_violation = StudyRoomViolation.create! valid_attributes
        get study_room_violation_url(study_room_violation)
        expect(response).to be_successful
      end
    end

    describe 'GET /new' do
      it 'renders a successful response' do
        get new_study_room_violation_url(study_room_violation: { study_room_id: study_room.id })
        expect(response).to be_successful
      end
    end

    describe 'GET /edit' do
      it 'render a successful response' do
        study_room_violation = StudyRoomViolation.create! valid_attributes
        get edit_study_room_violation_url(study_room_violation)
        expect(response).to be_successful
      end
    end

    describe 'POST /create' do
      context 'with valid parameters' do
        it 'creates a new StudyRoomViolation' do
          expect do
            post study_room_violations_url, params: { study_room_violation: valid_attributes }
          end.to change(StudyRoomViolation, :count).by(1)
        end

        it 'redirects to the created study_room_violation' do
          post study_room_violations_url, params: { study_room_violation: valid_attributes }
          expect(response).to redirect_to(study_room_violation_url(StudyRoomViolation.last))
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new StudyRoomViolation' do
          expect do
            post study_room_violations_url, params: { study_room_violation: invalid_attributes }
          end.not_to change(StudyRoomViolation, :count)
        end

        it "renders a unprocessable response (i.e. to display the 'new' template)" do
          post study_room_violations_url, params: { study_room_violation: invalid_attributes }
          expect(response).to be_unprocessable
        end
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:new_attributes) do
          { study_room_id: study_room.id, user_id: violation_user.id, number_of_books: 21 }
        end

        it 'updates the requested study_room_violation' do
          study_room_violation = StudyRoomViolation.create! valid_attributes
          patch study_room_violation_url(study_room_violation), params: { study_room_violation: new_attributes }
          study_room_violation.reload
          expect(study_room_violation.number_of_books).to eq(21)
        end

        it 'redirects to the study_room_violation' do
          study_room_violation = StudyRoomViolation.create! valid_attributes
          patch study_room_violation_url(study_room_violation), params: { study_room_violation: new_attributes }
          study_room_violation.reload
          expect(response).to redirect_to(study_room_violation_url(study_room_violation))
        end
      end

      context 'with invalid parameters' do
        it 'renders an unprocessable entity' do
          study_room_violation = StudyRoomViolation.create! valid_attributes
          patch study_room_violation_url(study_room_violation), params: { study_room_violation: invalid_attributes }
          expect(response).to be_unprocessable
        end
      end
    end

    describe 'DELETE /destroy' do
      it 'destroys the requested study_room_violation' do
        study_room_violation = StudyRoomViolation.create! valid_attributes
        expect do
          delete study_room_violation_url(study_room_violation)
        end.to change(StudyRoomViolation, :count).by(-1)
      end

      it 'redirects to the study_room_violations list' do
        study_room_violation = StudyRoomViolation.create! valid_attributes
        delete study_room_violation_url(study_room_violation)
        expect(response).to redirect_to(study_room_violations_url)
      end
    end
  end
end
