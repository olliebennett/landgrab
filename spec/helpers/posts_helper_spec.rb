# frozen_string_literal: true

require "#{File.dirname(__FILE__)}/../../app/helpers/posts_helper"

RSpec.describe PostsHelper do
  describe '#markdown' do
    it 'renders images with rounded corners' do
      markdown = '![my_alt_text](/my_img.png "my_title")'
      html = helper.markdown(markdown)

      expect(html).to eq %(<p><image src="/my_img.png" title="my_title" alt="my_alt_text" class="rounded img-fluid" /></p>\n)
    end
  end
end
