require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe 'full title method' do

    context 'when title is blank' do
      it 'provides the default title' do
        expect(full_title).to eq 'BIGBAG Store'
      end
    end

    context 'when title is not blank' do
      it 'provides the (title) | BIGBAG Store' do
        expect(full_title('one')).to eq 'one | BIGBAG Store'
      end
    end
  end
end
