class Pdns::API
  abstract class Endpoint
    def initialize(@api : API, @base_path : String)
    end

    private def get(path, type : T.class, **query_params) : T forall T
      @api.exec("GET", "#{@base_path}#{path}", type, **query_params)
    end

    private def put(path, type : T.class, body, **query_params) : T forall T
      @api.exec("PUT", "#{@base_path}#{path}", type, body, **query_params)
    end

    private def patch(path, type : T.class, body, **query_params) : T forall T
      @api.exec("PATCH", "#{@base_path}#{path}", type, body, **query_params)
    end

    private def post(path, type : T.class, body, **query_params) : T forall T
      @api.exec("POST", "#{@base_path}#{path}", type, body, **query_params)
    end

    private def delete(path, type : T.class, **query_params) : T forall T
      @api.exec("DELETE", "#{@base_path}#{path}", type, **query_params)
    end

    macro scoped
      class Scoped
        def initialize(@api : API, @base_path : String)
        end
      end

      {{yield}}

      def with(id : String, &block : Scoped -> T) : T forall T
        yield Scoped.new(@api, "#{@base_path}/#{id}/")
      end
    end

    macro endpoint(endpoint)
      class Scoped
        def {{endpoint.var}} : {{endpoint.type}}
          @{{endpoint.var.underscore}} ||= {{endpoint.type}}.new(@api, "#{@base_path}{{endpoint.var.tr("_", "-")}}")
        end
      end
    end
  end
end
