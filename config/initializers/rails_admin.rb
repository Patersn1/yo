RailsAdmin.config do |config|
  config.model 'User' do
    edit do
      configure :favorite_opportunities do
        hide
      end

      configure :favorite_organizations do
        hide
      end
    end
  end

  config.model 'Tag' do
    edit do
      configure :favorite_opportunities do
        hide
      end

      configure :organizations do
        hide
      end
    end
  end
end