/*
* Copyright (c) 2016-2017 elementary LLC (https://elementary.io)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*/

public class AppCenter.Widgets.HumbleButton : Gtk.Grid {
    public signal void download_requested ();
    public signal void payment_requested (int amount);

    private HumbleButtonAmountModifier selection;
    private Gtk.Button amount_button;

    private Gtk.ToggleButton arrow_button;

    private int _amount;
    public int amount {
        get {
            return _amount;
        }
        set {
            _amount = value;
            amount_button.label = get_amount_formatted (value, true);
            selection.amount = value;

            if (_amount != 0) {
                amount_button.label = get_amount_formatted (_amount, true);
            } else {
                amount_button.label = free_string;
            }
        }
    }

    private string free_string;
    public string label {
        set {
            free_string = value;

            if (amount == 0) {
               amount_button.label = free_string;
            }
        }
    }

    public bool can_purchase {
        set {
            if (!value) {
                amount = 0;
            }

            arrow_button.visible = value;
            arrow_button.no_show_all = !value;
        }
    }

    public bool suggested_action {
        set {
            if (value) {
                amount_button.get_style_context ().add_class ("h3");
                amount_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
                arrow_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            }
        }
    }

    public HumbleButton () {
        Object (amount: 1);
    }

    construct {
        amount_button = new Gtk.Button.with_label (_("Free"));
        amount_button.hexpand = true;

        amount_button.clicked.connect (() => {
            if (this.amount != 0) {
                payment_requested (this.amount);
            } else {
                download_requested ();
            }
        });

        arrow_button = new Gtk.ToggleButton ();
        arrow_button.image = new Gtk.Image.from_icon_name ("pan-down-symbolic", Gtk.IconSize.MENU);

        selection = new HumbleButtonAmountModifier (arrow_button);

        arrow_button.toggled.connect (() => {
            selection.show_all ();
        });

        selection.amount_update.connect ((_amount) => {
            amount = _amount;
        });

        selection.payment_requested.connect ((_amount) => { payment_requested (_amount); });
        selection.download_requested.connect (() => { download_requested (); });

        selection.closed.connect (() => {
            arrow_button.active = false;
        });

        get_style_context ().add_class (Gtk.STYLE_CLASS_LINKED);

        add (amount_button);
        add (arrow_button);
    }

    private string get_amount_formatted (int _amount, bool with_short_part = true) {
        if (with_short_part) {
            /// This amount will be US Dollars. Some languages might need a "$%dUSD"
            return _("$%d.00").printf (_amount);
        } else {
            /// This amount will be US Dollars. Some languages might need a "$%dUSD"
            return _("$%d").printf (_amount);
        }
    }
}

