package pe.com.hermes.appmobile.data.remote.dto;

import java.util.ArrayList;
import java.util.List;

public class PageData<T> {
    public List<T> content = new ArrayList<>();
    public PageMeta page = new PageMeta();
}
