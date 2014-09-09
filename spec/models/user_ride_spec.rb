require 'spec_helper'

describe UserRide do
    let(:user_ride) { FactoryGirl.create(:user_ride) }
    subject { user_ride }

    it { should respond_to(:ride) }
    it { should respond_to(:user) }
end
