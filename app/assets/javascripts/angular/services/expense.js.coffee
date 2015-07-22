App.factory "Expense", ['railsResourceFactory', (railsResourceFactory) ->
  railsResourceFactory
    url: '/expenses'
    name: 'expense'
]