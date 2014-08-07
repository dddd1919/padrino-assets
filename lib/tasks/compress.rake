namespace :assets do
  desc 'Compresses all compiled assets'
  task :compress => :environment do
    environment = Padrino::Assets.environment
    manifest = Padrino::Assets.manifest
    manifest.assets.each do |asset, digested_asset|
      if asset = environment[asset]
        compressed_asset = File.join(manifest.dir, digested_asset)
        if digested_asset.end_with?(".js")
          compress_file = (Uglifier.compile(File.read(compressed_asset)))
          js_file = File.new(compressed_asset, 'w')
          js_file.print(compress_file)
          js_file.close
        elsif digested_asset.end_with?('.css')
          compress_file = CSSminify.compress(File.read(compressed_asset))
          css_file = File.new(compressed_asset, 'w')
          css_file.print(compress_file)
          css_file.close
        end
        asset.write_to(compressed_asset + '.gz') if compressed_asset =~ /\.(?:css|html|js|svg|txt|xml)$/
      end
    end
  end
  end
end