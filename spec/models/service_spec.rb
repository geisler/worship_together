require 'spec_helper'

describe Service do
    let(:service) { FactoryGirl.create(:service) }
    subject { service }

    it { should respond_to(:day_of_week) }
    it { should respond_to(:start_time) }
    it { should respond_to(:finish_time) }
    it { should respond_to(:location) }

    it { should respond_to(:church) }
    it { should respond_to(:rides) }

    describe "required Church relationship" do
	before { service.church_id = nil }

	it { should_not be_valid }
    end
end
