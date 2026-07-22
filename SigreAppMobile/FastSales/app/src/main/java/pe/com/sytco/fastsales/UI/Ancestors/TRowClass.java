package pe.com.sytco.fastsales.UI.Ancestors;

import android.widget.ImageButton;
import android.widget.TableRow;

public class TRowClass{
    public TableRow _trRowSelected = null;
    public Integer _iiRowSelected = 0;
    public ImageButton _ibButtonSelected = null;

    public TRowClass(TableRow atRow, ImageButton aIbButton, Integer aiRow) {
        this._iiRowSelected = aiRow;
        this._trRowSelected = atRow;
        this._ibButtonSelected = aIbButton;
    }
}
