local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local types = require "luasnip.util.types"

local function node_with_virtual_text(pos, node, text)
  local nodes
  if node.type == types.textNode then
    node.pos = 2
    nodes = { i(1), node }
  else
    node.pos = 1
    nodes = { node }
  end
  return sn(pos, nodes, {
    node_ext_opts = {
      active = {
        -- override highlight here ("GruvboxOrange").
        virt_text = { { text, "GruvboxOrange" } },
      },
    },
  })
end

local function nodes_with_virtual_text(nodes, opts)
  if opts == nil then opts = {} end
  local new_nodes = {}
  for pos, node in ipairs(nodes) do
    if opts.texts[pos] ~= nil then node = node_with_virtual_text(pos, node, opts.texts[pos]) end
    table.insert(new_nodes, node)
  end
  return new_nodes
end

local function choice_text_node(pos, choices, opts)
  choices = nodes_with_virtual_text(choices, opts)
  return c(pos, choices, opts)
end

local ct = choice_text_node

ls.add_snippets("python", {
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                          ROOT                           │
  -- ╰─────────────────────────────────────────────────────────╯
  s("rootth1d", fmt('ROOT.TH1D("{}", "{}", {})', { i(1, "h"), i(2, "h"), i(3) })),
  s("rootth2d", fmt('ROOT.TH2D("{}", "{}", {})', { i(1, "h"), i(2, "h"), i(3) })),
  s("rootbatch", t { "ROOT.gROOT.SetBatch(True)" }),
  s(
    "bookds",
    fmt(
      [[
df.Book(
  ROOT.std.move(ROOT.RooDataSetHelper("data", "data", ROOT.RooArgSet(x))),
  ["B_DTFDict_B_M"]
)
  ]],
      {}
    )
  ),
  s(
    "rootdf",
    c(1, {
      fmt('df = ROOT.RDataFrame("{}", {})', { i(1, "DecayTree"), i(2, "file_list") }),
      fmt(
        [[
file_list = ["{}"]
df = ROOT.RDataFrame("{}", file_list)
    ]],
        { i(1), i(2, "DecayTree") }
      ),
    })
  ),
  s(
    "rootimt",
    c(1, {
      t {
        'ps.add_argument("--ncpu", type=int, default=0)',
        "ROOT.EnableImplicitMT(args.ncpu)",
        'print(f"Enabled multithreading with {args.ncpu} CPUs...")',
      },
      t {
        "ROOT.EnableImplicitMT()",
      },
    })
  ),
  s("rootlegend", t { "lg = ROOT.TLegend(0.7,0.7,0.9,0.9)", "lg.SetFillStyle(4000)", "lg.SetBorderSize(0)" }),
  s(
    "root",
    t {
      "import ROOT",
      "ROOT.gROOT.SetBatch(True)",
    }
  ),
  s(
    "roottcanvas",
    fmt(
      [[
  c = ROOT.TCanvas("c", "c", {})
  {}
  c.SaveAs("{}")
  ]],
      {
        i(1, "800, 600"),
        i(0),
        i(2, "test.pdf"),
      }
    )
  ),
  s(
    "gaudi debug",
    t {
      "from Gaudi.Configuration import DEBUG",
      "options.output_level = DEBUG",
    }
  ),
  s(
    "agg",
    t {
      "import matplotlib as mpl",
      'mpl.use("Agg")',
    }
  ),
  s(
    "cwd",
    t {
      "import os",
      "cwd = os.path.dirname(os.path.abspath(__file__))",
    }
  ),
  s(
    "syspath",
    fmt(
      [[
      import sys
      sys.path.append("{}")
      ]],
      { i(1, "..") }
    )
  ),
  s(
    "osexists",
    fmt("os.path.exists({file})", {
      file = i(1),
    })
  ),
  s(
    "yearpol",
    t {
      "for year in args.years:",
      "\tfor pol in args.pols:",
    }
  ),
  s(
    "argg",
    fmt(
      [[
      from argparse import ArgumentParser as AP
      from argparse import ArgumentDefaultsHelpFormatter as ADHF
      ps = AP(formatter_class=ADHF)
      ps.add_argument("--test", action="store_true")
      args = ps.parse_args()
      ]],
      {}
    )
  ),
  s(
    "argyears",
    t {
      'ps.add_argument("--years",nargs="+",type=str,default=["16", "17", "18"],choices=["16", "17","18"])',
    }
  ),
  s(
    "argpols",
    t {
      'ps.add_argument("--pols",nargs="+",type=str,default=["Down", "Up"],choices=["Down", "Up"])',
    }
  ),
  s(
    "d",
    fmt(
      [[
		def {func}({args}){ret}:
			{doc}{body}
	]],
      {
        func = i(1),
        args = i(2),
        ret = c(3, {
          t "",
          sn(nil, {
            t " -> ",
            i(1),
          }),
        }),
        doc = isn(4, {
          ct(1, {
            t "",
            -- NOTE we need to surround the `fmt` with `sn` to make this work
            sn(
              1,
              fmt(
                [[
			"""{desc}"""

			]],
                { desc = i(1) }
              )
            ),
            sn(
              2,
              fmt(
                [[
			"""{desc}

			Args:
			{args}

			Returns:
			{returns}
			"""

			]],
                {
                  desc = i(1),
                  args = i(2), -- TODO should read from the args in the function
                  returns = i(3),
                }
              )
            ),
          }, {
            texts = {
              "(no docstring)",
              "(single line docstring)",
              "(full docstring)",
            },
          }),
        }, "$PARENT_INDENT\t"),
        body = i(0),
      }
    )
  ),
})
