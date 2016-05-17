require 'rails_helper'

describe MoviesController do
    
    let(:good_attributes){{:title => 'The Killer', :rating => 'PG-13', :description => '', :release_date => Time.now, :director => 'Clifton Taylor'}}
	let(:bad_attributes){{:title => 'The Helper', :rating => 'R', :description => 'something', :release_date => Time.now, :director => 'James Taylor'}}

  describe 'find a movie' do
    it 'should show the movie information' do
      movie = double('Movie')
      Movie.should_receive(:find).with('1').and_return(movie)
      get :show, {:id => '1'}
      response.should render_template('show')
    end
  end

  describe 'list all movies' do

    it 'should find and list all movies' do
      get :index
      response.should render_template('index')
    end

    it 'should find list all movies, sort by title' do
      get :index, {:sort => 'title', :ratings => 'PG'}
      response.should redirect_to(:sort => 'title', :ratings => 'PG')
    end

    it 'should find list all movies, sort by release_date' do
      get :index, {:sort => 'release_date', :ratings => 'PG'}
      response.should redirect_to(:sort => 'release_date', :ratings => 'PG')
    end

    it 'should find list all movies with rating PG' do
      get :index, {:ratings => 'PG'}
      response.should redirect_to(:ratings => 'PG')
    end

  end

  describe 'show form to add a movie' do
    it 'should show the form for user to create new movie information' do
      get :new
      response.should render_template('new')
    end    
  end

  describe 'Create movies' do 
    it'should be create movies' do
	    post :create, {:movie => {:title => 'The Killer', :rating => 'PG-13', :description => '', :release_date => Time.now, :director => 'Clifton Taylor'}}
        expect(assigns(:movie)).to be_a(Movie)
        expect(assigns(:movie)).to be_persisted
	end
  end

  describe 'edit a movie' do
    it 'should show the form to edit the movie information' do
      movie = double('Movie', :title => 'The Help')
      Movie.should_receive(:find).with('1').and_return(movie)
      get :edit, :id => '1'
      response.should render_template('edit')
    end
  end

  describe 'delete a movie' do
    it 'should delete the movie' do
      movie = double('Movie', :id => '1', :title => 'The Help')
      Movie.should_receive(:find).with('1').and_return(movie)
      movie.should_receive(:destroy)
      delete :destroy, :id => '1'
      response.should redirect_to(movies_path)
    end
  end
  
  describe "Update movies" do

	  it "should redirect to the movie" do
        movies = Movie.create! good_attributes
        put :update, {:id => movies.to_param, :movie => good_attributes}
        expect(response).to redirect_to(movie_path(movies))
      end

       it "should update the requested movie" do
        movies = Movie.create! good_attributes
        put :update, {:id => movies.to_param, :movie => good_attributes}
        movies.reload
        expect(Movie.last).to eq(movies)
      end
  end
  
  describe 'When Director is missing' do
	  it 'When I go to the similar movies page ' do 
		movie = Movie.create! bad_attributes
      	get 'similar_director', {:movie_id => movie.to_param}	
      	expect(assigns(:movie)).to eq(movie)
  	  end
	end
end