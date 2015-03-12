require 'spec_helper'

describe Video do

  it 'saves itself' do
    video = Video.create(title: 'Mary Poppins', description: 'Mary Poppins')

    expect(Video.first).to eq(video)
  end
end