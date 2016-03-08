require "spec_helper"

describe InvitationsController do

  describe 'GET #new' do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    context 'authenticated users' do
      before do
        set_current_user

        get :new
      end

      it 'should render the new template' do
        expect(response).to render_template 'new'
      end

      it 'initializes the @invitation variable with an Invitation instance' do
        expect(assigns(:invitation)).to be_a_new Invitation
      end
    end
  end

  describe 'POST #create' do
    let(:invitation_params) { Fabricate.attributes_for(:invitation) }

    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    context 'authenticated users' do
      let(:user) { Fabricate(:user) }

      before { set_current_user(user) }

      context 'with valid input' do
        before { post :create, invitation: invitation_params }

        it 'creates the invitation' do
          expect(Invitation.count).to eq 1
        end

        it 'sets the current user as the author of the invitation' do
          expect(Invitation.first.author).to eq user
        end

        it 'sets the token of the Invitation' do
          expect(Invitation.first.token).to be_present
        end

        it 'sets the flash message' do
          expect(flash[:success]).to be_present
        end

        it 'redirects to the invitation new page' do
          expect(response).to redirect_to new_invitation_path
        end

        context 'invitation email' do
          it 'sends the email' do
            expect(ActionMailer::Base.deliveries.count).to eq 1
          end

          it 'sends to the right recipient' do
            message = ActionMailer::Base.deliveries.last
            expect(message.to).to eq [ invitation_params[:email] ]
          end

          it "contains the registration link with the invitation token" do
            email = ActionMailer::Base.deliveries.last
            expect(email.body.encoded).to include register_with_invitation_url(Invitation.last.token)
          end
        end

      end

      context 'with invalid input' do
        before { post :create, invitation: invitation_params.except(:name) }

        it 'doesnt create the Invitation' do
          expect(Invitation.all).to be_empty
        end

        it 'does not send an email' do
          expect(ActionMailer::Base.deliveries).to be_empty
        end

        it 'sets the @invitation variable' do
          expect(assigns(:invitation)).to be_a_new(Invitation)
        end

        it 'sets the validation errors' do
          expect(assigns(:invitation).errors.messages).to be_present
        end

        it 'renders the new template' do
          expect(response).to render_template 'new'
        end

      end

    end
  end

end
