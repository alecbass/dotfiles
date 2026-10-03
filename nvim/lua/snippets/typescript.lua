local luasnip = require("luasnip")
-- Shorthands
local s = luasnip.snippet
local sn = luasnip.snippet_node
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node
local c = luasnip.choice_node
local d = luasnip.dynamic_node
local r = luasnip.restore_node

local fmt = require("luasnip.extras.fmt").fmt
local utils = require("snippets.utils")

return {
	s(
		"web",
		fmt(
			[[
              export class {} extends HTMLElement {{
                static observedAttributes = [];

                connectedCallback() {{}}

                disconnectedCallback() {{}}

                attributeChangedCallback(name: string, oldValue: string | null, newValue: string | null) {{}}
              }}

              customElements.define("{}", {});

              declare global {{
                interface HTMLElementTagNameMap {{
                  "{}": {};
                }}
              }}

            ]],
			{
				-- It would be nice to use named keys here, but we get a weird position_so_far not found error when re-using
				-- the same formatting key
				d(1, utils.insert_class_name, {}, {}),
				d(2, utils.insert_tag_name, {}, {}),
				d(3, utils.insert_class_name, {}, {}),
				d(4, utils.insert_tag_name, {}, {}),
				d(5, utils.insert_class_name, {}, {}),
			}
		)
	),
	s(
		"lit",
		fmt(
			[[
              import {{ html, css, LitElement }} from "lit";
              import {{ customElement, property }} from "lit/decorators.js";

              @customElement("{}")
              export class {} extends LitElement {{
                static styles = css``;

                @property()
                private value: string = "placeholder";

                connectedCallback(): void {{
                  super.connectedCallback();
                }}

                disconnectedCallback(): void {{
                  super.disconnectedCallback();
                }}

                render() {{
                  return html`
                  `;
                }}
              }}

              declare global {{
                interface HTMLElementTagNameMap {{
                  "{}": {};
                }}
              }}

            ]],
			{
				-- It would be nice to use named keys here, but we get a weird position_so_far not found error when re-using
				-- the same formatting key
				d(1, utils.insert_tag_name, {}, {}),
				d(2, utils.insert_class_name, {}, {}),
				d(3, utils.insert_tag_name, {}, {}),
				d(4, utils.insert_class_name, {}, {}),
			}
		)
	),
	s("class", {
		-- Choice: Switch between two different Nodes, first parameter is its position, second a list of nodes.
		c(1, {
			t("public "),
			t("private "),
		}),
		t("class "),
		i(2),
		t(" "),
		c(3, {
			t("{"),
			-- sn: Nested Snippet. Instead of a trigger, it has a position, just like insertNodes. !!! These don't expect a 0-node!!!!
			-- Inside Choices, Nodes don't need a position as the choice node is the one being jumped to.
			sn(nil, {
				t("extends "),
				-- restoreNode: stores and restores nodes.
				-- pass position, store-key and nodes.
				r(1, "other_class", i(1)),
				t(" {"),
			}),
			sn(nil, {
				t("implements "),
				-- no need to define the nodes for a given key a second time.
				r(1, "other_class"),
				t(" {"),
			}),
		}),
		t({ "", "\t" }),
		i(0),
		t({ "", "}" }),
	}),
	s(
		"fmt1",
		fmt("To {title} {} {}.", {
			i(2, "Name"),
			i(3, "Surname"),
			title = c(1, { t("Mr."), t("Ms.") }),
		})
	),
	-- Lambda function
	s(
		"lfn",
		fmt(
			[[
              () => {{
                {style}
              }});
            ]],
			{
				-- It would be nice to use named keys here, but we get a weird position_so_far not found error when re-using
				-- the same formatting key
				style = c(1, {
					t("hello"),
					t("yep"),
				}),
				-- t("console.debug(\"hi\")")
			}
		)
	),
	-- Class function
	--
	s(
		"cfn",
		fmt(
			[[
              {public} {name}() {{
                {body}
              }});
            ]],
			{
				-- It would be nice to use named keys here, but we get a weird position_so_far not found error when re-using
				-- the same formatting key
				public = c(1, {
					t("public"),
					t("private"),
				}),
				name = t(io.read("*l")),
				body = t('console.debug("test");'),
			}
		)
	),
}
