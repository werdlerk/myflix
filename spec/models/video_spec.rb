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

end