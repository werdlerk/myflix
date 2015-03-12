require 'spec_helper'

describe Video do

  it 'saves itself' do
    video = Video.create(title: 'Mary Poppins', description: 'Mary Poppins')

    expect(Video.first).to eq(video)
  end

  it 'belongs to a category' do
    category = Category.create(name:'Oldies')
    video = Video.create(title: 'Mary Poppins', description: 'Mary Poppins', category:category )

    expect(Video.first.category).to eq(category)
  end

  it 'validates the required title' do
    video = Video.new(description: 'Wop wop wop')
    video.save

    expect(Video.count).to eq(0)
    expect(video.errors.keys).to include(:title)
  end 

  it 'validates the required description' do
    video = Video.new(title: 'Maze Runner')
    video.save

    expect(Video.count).to eq(0)
    expect(video.errors.keys).to include(:description)
  end

end