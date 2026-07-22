package pe.com.sytco.fastsales.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.List;

import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.BeanItemSearch;

public class ListViewSearchAdapter extends ArrayAdapter<BeanItemSearch> {

    public ListViewSearchAdapter(@NonNull Context context, List<BeanItemSearch> objects) {
        super(context, 0, objects);
    }

    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            convertView = LayoutInflater.from(getContext())
                    .inflate(R.layout.item_row_search, parent, false);
            holder = new ViewHolder();
            holder.tvItem1 = convertView.findViewById(R.id.tvItem1);
            holder.tvItem2 = convertView.findViewById(R.id.tvItem2);
            holder.tvItem3 = convertView.findViewById(R.id.tvItem3);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        BeanItemSearch item = getItem(position);
        if (item == null) {
            return convertView;
        }

        holder.tvItem1.setText(item.getCadena1() != null ? item.getCadena1() : "");

        if (item.getCadena2() != null && !item.getCadena2().equals("")) {
            holder.tvItem2.setText(item.getCadena2());
            holder.tvItem2.setVisibility(View.VISIBLE);
        } else {
            holder.tvItem2.setText("");
            holder.tvItem2.setVisibility(View.GONE);
        }

        if (item.getCadena3() != null && !item.getCadena3().equals("")) {
            holder.tvItem3.setText(item.getCadena3());
            holder.tvItem3.setVisibility(View.VISIBLE);
        } else {
            holder.tvItem3.setText("");
            holder.tvItem3.setVisibility(View.GONE);
        }

        return convertView;
    }

    private static final class ViewHolder {
        TextView tvItem1;
        TextView tvItem2;
        TextView tvItem3;
    }
}
