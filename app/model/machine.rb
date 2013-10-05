class Machine
    include Mongoid::Document

    field :monit, type: Hash
end
