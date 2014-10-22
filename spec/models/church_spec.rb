require 'spec_helper'

describe Church do
    let(:church) { FactoryGirl.create(:church) }
    subject { church }

    it { should respond_to(:name) }
    it { should respond_to(:picture) }
    it { should respond_to(:web_site) }
    it { should respond_to(:description) }

    it { should respond_to(:user) }
    it { should respond_to(:services) }

    describe "required User relationship" do
	before { church.user_id = nil }

	it { should_not be_valid }
    end
end
