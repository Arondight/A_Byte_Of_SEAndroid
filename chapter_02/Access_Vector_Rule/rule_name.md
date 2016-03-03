#### `rule_name`

| rule_name | 作用 |
| --- | --- |
| allow | 允许主体对客体某类型具有某权限 |
| neverallow | 类似allow，但作用为禁止 |
| auditallow | 如果策略被allow 允许，事件发生时强制记录事件 |
| dontaudit | 如果策略被neverallow 禁止，事件发生时强制**不**记录事件 |

