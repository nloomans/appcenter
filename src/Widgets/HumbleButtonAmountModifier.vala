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

public class AppCenter.Widgets.HumbleButtonAmountModifier : Gtk.Popover {
    public signal void payment_requested (int amount);

    public HumbleButtonAmountModifier (Gtk.Widget relative_to) {
        //  chain up is not supported, so we cain't do `base (relative_to);`
        set_relative_to (relative_to);
    }

    construct {
        var selection_list = new Gtk.Grid ();

        selection_list.column_spacing = 6;
        selection_list.margin = 12;

        var one_dollar = get_amount_button (1);
        var five_dollar = get_amount_button (5);
        var ten_dollar = get_amount_button (10);

        var custom_label = new Gtk.Label ("$");
        custom_label.margin_start = 12;

        var custom_amount = new Gtk.SpinButton.with_range (0, 100, 1);

        selection_list.add (one_dollar);
        selection_list.add (five_dollar);
        selection_list.add (ten_dollar);
        selection_list.add (custom_label);
        selection_list.add (custom_amount);

        position = Gtk.PositionType.BOTTOM;
        add (selection_list);
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

    private Gtk.Button get_amount_button (int amount) {
        var button = new Gtk.Button.with_label (get_amount_formatted (amount, false));

        button.clicked.connect (() => {
            this.hide ();
            payment_requested (amount);
        });

        return button;
    }
}