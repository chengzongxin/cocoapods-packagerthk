module Pod
  class SpecBuilder
    def initialize(spec, source, embedded, dynamic, generate_spec)
      @spec = spec
      @source = source.nil? ? '{ :path => \'.\' }' : source
      @embedded = embedded
      @dynamic = dynamic
      @is_generate_spec = generate_spec
      @generate_spec = ""
    end

    def framework_path
      if @embedded
        @spec.name + '.embeddedframework' + '/' + @spec.name + '.framework'
      else
        @spec.name + '.framework'
      end
    end

    def spec_platform(platform)
      fwk_base = platform.name.to_s + '/' + framework_path
      spec = <<RB
  s.#{platform.name}.deployment_target    = '#{platform.deployment_target}'
  s.#{platform.name}.vendored_framework   = '#{fwk_base}'
RB

      %w(frameworks weak_frameworks libraries requires_arc xcconfig).each do |attribute|
        attributes_hash = @spec.attributes_hash[platform.name.to_s]
        next if attributes_hash.nil?
        value = attributes_hash[attribute]
        next if value.nil?

        value = "'#{value}'" if value.class == String
        spec += "  s.#{platform.name}.#{attribute} = #{value}\n"
      end
      spec

      
    end

    def spec_sources_pattern(generate_spec)
      # 添加Source Pattern
      spec = <<RB

  if ENV['IS_SOURCE'] || ENV["\#{s.name}_SOURCE"]
    s.source           = { :git => '#{@spec.attributes_hash['source']['git']}', :commit => "#{@spec.attributes_hash['source']['commit']}" }
RB

        %w(source_files public_header_files resources frameworks resource_bundles dependencies).each do |attribute|
        value = @spec.attributes_hash[attribute]
        next if value.nil?
          if attribute == 'dependencies'
            value.each { |key,hashvalue|
            if hashvalue.empty?
              spec += "    s.dependency \'#{key}\'\n"
            else
              spec += "    s.dependency \'#{key}\', \'#{hashvalue[0]}\'\n"
            end
            }
          else
              value = value.dump if value.class == String
              spec += "    s.#{attribute} = #{value}\n"
          end
        end
        #添加subspec (递归添加)
        @generate_spec = spec
        @spec.subspecs.each do |subspec|
          spec_sources_pattern_subpsec(subspec)
        end
        spec = @generate_spec

      # 添加Framwork Pattern
      spec += <<RB
  else
    s.source           = { :git => 'git@repo.we.com:iosfeaturelibraries/frameworkrepo.git', :commit => 'xxx'}
    s.source_files = "\#{s.name}-\#{s.version}/ios/\#{s.name}.framework/Headers/*.h"
    s.public_header_files = "\#{s.name}-\#{s.version}/ios/\#{s.name}.framework/Headers/*.h"
    s.ios.vendored_framework = "\#{s.name}-\#{s.version}/ios/\#{s.name}.framework"
  end
RB
      # cur_work_dir = Dir::getwd
      # Dir.chdir('/Users/joe.cheng/cocoapods-debug')
      # File.open('debug' + '.podspec', 'w') { |file| file.write(spec) }
      # Dir.chdir(cur_work_dir)
      spec
    end

    def spec_sources_pattern_subpsec(subspec)
        name = subspec.attributes_hash['name']
        level = subspec.name.split('/').count
        curSpec = "s" * (level - 1)
        space = "  " * (level - 2)
        nextSpec = curSpec + "s"
        @generate_spec += space
        @generate_spec += "    #{curSpec}.subspec \'#{name}\' do |#{nextSpec}|\n"
        
        %w(source_files public_header_files resources frameworks resource_bundles dependencies).each do |attribute|
          value = subspec.attributes_hash[attribute]
          next if value.nil?
          @generate_spec += space
          if attribute == 'dependencies'
            value.each { |key,hashvalue|
            if hashvalue.empty?
              @generate_spec += "      #{nextSpec}.dependency \'#{key}\'\n"
            else
              @generate_spec += "      #{nextSpec}.dependency \'#{key}\', \'#{hashvalue[0]}\'\n"
            end
            }
          else
            value = value.dump if value.class == String
            @generate_spec += "      #{nextSpec}.#{attribute} = #{value}\n"
          end
        end

        if subspec.subspecs.empty?
          @generate_spec += space
          @generate_spec += "    end\n"
        else
          #添加subspec
          subspec.subspecs.each do |subsubspec|
            spec_sources_pattern_subpsec(subsubspec)
          end
          @generate_spec += "    end\n"
        end
    end

    def spec_metadata
      spec = spec_header
      spec
    end

    def spec_close
      "end\n"
    end

    private

    def spec_header
      spec = "Pod::Spec.new do |s|\n"

      %w(name version summary license authors homepage description social_media_url
         docset_url documentation_url screenshots frameworks weak_frameworks libraries requires_arc
         deployment_target xcconfig).each do |attribute|
        value = @spec.attributes_hash[attribute]
        next if value.nil?
        value = value.dump if value.class == String
        spec += "  s.#{attribute} = #{value}\n"
      end
      if @is_generate_spec
        source = spec_sources_pattern(true)
        spec += "#{source}"
      else
        spec += "  s.source = #{@source}\n\n"
      end
      spec
    end
  end
end
