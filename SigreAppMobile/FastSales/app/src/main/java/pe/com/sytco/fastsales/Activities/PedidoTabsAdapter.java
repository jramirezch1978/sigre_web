package pe.com.sytco.fastsales.Activities;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;

import java.util.ArrayList;
import java.util.List;

/**
 * Adaptador de pestañas para tomapedidos multipestaña.
 */
public class PedidoTabsAdapter extends FragmentPagerAdapter {

    private final List<PedidoTabFragment> fragments = new ArrayList<>();
    private final List<String> titles = new ArrayList<>();

    public PedidoTabsAdapter(@NonNull FragmentManager fm) {
        super(fm, BEHAVIOR_RESUME_ONLY_CURRENT_FRAGMENT);
    }

    @NonNull
    @Override
    public Fragment getItem(int position) {
        return fragments.get(position);
    }

    @Override
    public int getCount() {
        return fragments.size();
    }

    @Nullable
    @Override
    public CharSequence getPageTitle(int position) {
        return titles.get(position);
    }

    @Override
    public int getItemPosition(@NonNull Object object) {
        // Existentes: no recrear. Eliminados: POSITION_NONE.
        // Devolver el índice forzó re-tag del Fragment y crash:
        // "Can't change tag of fragment ... was :2 now :<hashCode>"
        if (fragments.contains(object)) {
            return POSITION_UNCHANGED;
        }
        return POSITION_NONE;
    }

    @Override
    public long getItemId(int position) {
        // Usar siempre el tabId de arguments (disponible antes de onViewCreated).
        // Si se usa el campo tabId (null hasta onViewCreated), el pager etiqueta
        // con position y luego con hashCode → IllegalStateException al cambiar tab.
        PedidoTabFragment fragment = fragments.get(position);
        String tabId = resolveTabId(fragment);
        if (tabId == null) {
            return position;
        }
        return tabId.hashCode();
    }

    @Nullable
    private static String resolveTabId(@Nullable PedidoTabFragment fragment) {
        if (fragment == null) {
            return null;
        }
        String tabId = fragment.getTabId();
        if (tabId != null) {
            return tabId;
        }
        if (fragment.getArguments() != null) {
            return fragment.getArguments().getString(PedidoTabFragment.ARG_TAB_ID);
        }
        return null;
    }

    public void addTab(@NonNull PedidoTabFragment fragment, @NonNull String title) {
        fragments.add(fragment);
        titles.add(title);
        notifyDataSetChanged();
    }

    public void removeTabAt(int index) {
        if (index < 0 || index >= fragments.size()) {
            return;
        }
        fragments.remove(index);
        titles.remove(index);
        notifyDataSetChanged();
    }

    public void updateTitle(int index, @NonNull String title) {
        if (index < 0 || index >= titles.size()) {
            return;
        }
        titles.set(index, title);
        // No llamar notifyDataSetChanged aquí: basta actualizar el texto del TabLayout.
    }

    public PedidoTabFragment getFragment(int position) {
        if (position < 0 || position >= fragments.size()) {
            return null;
        }
        return fragments.get(position);
    }

    public String getTitle(int position) {
        if (position < 0 || position >= titles.size()) {
            return "";
        }
        return titles.get(position);
    }

    public int indexOfTabId(@Nullable String tabId) {
        if (tabId == null) {
            return -1;
        }
        for (int i = 0; i < fragments.size(); i++) {
            PedidoTabFragment fragment = fragments.get(i);
            if (fragment != null && tabId.equals(fragment.getTabId())) {
                return i;
            }
        }
        return -1;
    }
}
