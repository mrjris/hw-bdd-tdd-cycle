require 'rails_helper'

describe Movie do
  describe 'search movies by director' do
    it 'should call find using director as keyword' do
      Movie.similar_director('George Lucas')
    end
  end
end
