class Machine
    include Mongoid::Document

    field :health_check_count, type: Integer
    field :health_check_status, type: String # Could be Running, Warning, Critical (Green, Yellow, Red)
    field :monit, type: Hash
end
