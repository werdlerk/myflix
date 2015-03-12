require 'spec_helper'

describe Category do 
  before(:each) do
    @category = Category.create(name: 'Action')
  end

  it 'can be saved' do
    expect(Category.first).to eq(@category)
  end

  it 'can have multiple videos associated' do
    video1 = Video.create(title: 'Battleship', description: 'A movie about ships', category: @category)
    video2 = Video.create(title: 'Mary Poppins', description: 'Mary Poppins', category: @category)

    expect(Category.first.videos.size).to eq(2)
    expect(Category.first.videos.first(2)).to include(video1, video2)
    expect(Category.first.videos.first(2)).to eq([video1, video2])
  end

end