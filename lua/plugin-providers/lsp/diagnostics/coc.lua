return {
  info       = { plug = 'coc-diagnostic-info'                      },
  next       = { plug = 'coc-diagnostic-next'                      },
  next_error = { plug = 'coc-diagnostic-next-error'                },
  prev       = { plug = 'coc-diagnostic-prev'                      },
  prev_error = { plug = 'coc-diagnostic-prev-error'                },
  refresh    = { cmd  = "call CocActionAsync('diagnosticRefresh')" }
}
