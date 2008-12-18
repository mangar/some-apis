module SomeAPI
  
    class Common
      
      require 'cgi'      
      
      #
      # :param => parameters from request as a Hash
      # :add => key par value to be added
      # :key_param_transaction => keys to be replaced from param 
      #   Ex.: param['name_of_the_parameter']
      #        param[:key_param_transaction] = {'name_of_the_parameter' => 'notp'}   
      # :remove => array with strings(keys) to be not inserted into final url
      # :url => base url with no parameters.
      #
      def self.parse_url(par = {})

        params = Hash.new

        # par[:param]
        # request parameters
        params.merge!(par[:param])
        
        # ... as default, removes action and controller keys from params
        params.delete("action")
        params.delete("controller")
        
        
        # par[:add]
        # add some parameters
        if (par.has_key?(:add)) then 
          par[:add].each_pair do |k,v|
            params[k] = v
          end
        end
        
        
        # par[:key_param_translation]
        # translate from one key to other...
        if (par.has_key?(:key_param_translation)) then 
          par[:key_param_translation].each_pair do |k,v|
            if (params.has_key?(k)) then
              value = params[k]
              params.delete(k)
              params[v] = value
            end
          end
        end
        
        
        # par[:remove]
        # add some parameters
        if (par.has_key?(:remove)) then 
          par[:remove].each do |v|
            params.delete(v)
          end
        end    
        
        
        url_pars = "?"
        
        #this is ordering by value because the kay can be a symbol, and this is nor orderable...
        # ordered_params = params.sort {|b,c| b[1] <=> c[1]}
        
        
        
        common = SomeAPI::Common.new 
        keys, new_params = common.order_hash(params)

        keys.each do |k|
          url_pars += "#{k}=#{CGI::escape(new_params[k])}&"
        end
        
        # params.each_pair do |k,v|
        #   url_pars += "#{k.to_s}=#{CGI::escape(v)}&"
        # end

        url = par[:url]
        url = (url.nil? ? "" : url) + url_pars[0, url_pars.size-1]

        return url
        
      end   
          
 
      # Order the keys of a Hash
      def order_hash hash
        new_hash = Hash.new
        hash.each_key { |k| new_hash[k.to_s] = hash[k] }
        keys_ordered = new_hash.keys.sort
        
        return keys_ordered, new_hash
      end
          
          
    end
    
end