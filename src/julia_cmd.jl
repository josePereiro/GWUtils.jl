function _julia_cmd_str()
    cmd_str = string(Base.julia_cmd())
    cmd_str = replace(cmd_str, "`" => "")
    return cmd_str
end