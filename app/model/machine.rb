class Machine
    include Mongoid::Document

    field :machine_id, type: String
    field :monit_json, type: String
    field :version, type: String
    field :created_at, type: Date
    field :updated_at, type: Date

end
