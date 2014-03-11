require 'spec_helper'

describe User do
    let(:user) { User.new }
    subject { user }

    it { should respond_to(:name) }
    it { should respond_to(:email) }
    it { should respond_to(:password) }
end
