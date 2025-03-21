require "rails_helper"

describe "/movies" do
  it "can be visited", points: 1 do
    visit "/movies"

    expect(page.status_code).to be(200)
  end

  it "has a link to /movies/new called 'New movie'", points: 1 do
    visit "/movies"

    expect(page).to have_link("New movie", href: "/movies/new")
  end
end

describe "/movies/new" do
  it "can be visited", points: 1 do
    visit "/movies/new"

    expect(page.status_code).to be(200)
  end

  it "has a form to add a new movie with method='post'", points: 1 do
    visit "/movies/new"

    expect(page).to have_form("/movies", :post)
  end

  it "has a hidden authenticity token input on the new movies form", points: 1 do
    visit "/movies/new"

    expect(page).to have_selector("input[name='authenticity_token']", visible: false)
  end

  it "creates a movie successfully", points: 1 do
    visit "/movies/new"

    fill_in "Title", with: "My test movie"
    fill_in "Description", with: "description"
    click_button "Create Movie"

    expect(page).to have_content("Movie was successfully created")
  end
end

describe "/movies/[ID]" do
  it "can be visited", points: 1 do
    movie = Movie.create(title: "My title", description: "My description")

    visit "/movies/#{movie.id}"

    expect(page.status_code).to be(200)
  end

  it "has a link to delete the movie with a DELETE request", points: 1 do
    movie = Movie.create(title: "My title", description: "My description")

    visit "/movies/#{movie.id}"

    expect(page).to have_selector("a[href='/movies/#{movie.id}'][data-turbo-method='delete']", text: 'Delete movie')
  end
end

describe "/movies/[ID]/edit" do
  it "can be visited", points: 1 do
    movie = Movie.create(title: "My title", description: "My description")

    visit "/movies/#{movie.id}/edit"

    expect(page.status_code).to be(200)
  end

  it "has a form", points: 1 do
    movie = Movie.create(title: "My title", description: "My description")

    visit "/movies/#{movie.id}/edit"

    expect(page).to have_selector("form[action='/movies/#{movie.id}'][method='post']")
  end

  it "has a hidden patch input", points: 1 do
    movie = Movie.create(title: "My title", description: "My description")

    visit "/movies/#{movie.id}/edit"

    expect(page).to have_selector("input[name='_method'][value='patch']", visible: false)
  end
end
