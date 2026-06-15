package com.sigre.core.util;

import org.junit.jupiter.api.Test;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import com.sigre.core.dto.PageDataDto;
import com.sigre.core.dto.PageInfoDto;

import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class PageDataFactoryTest {

    @Test
    void fromPage_mapsContentAndPageInfo() {
        List<String> items = List.of("A", "B", "C");
        Page<String> page = new PageImpl<>(items, PageRequest.of(2, 10), 53);

        PageDataDto<String> result = PageDataFactory.fromPage(page);

        assertThat(result.getContent()).containsExactly("A", "B", "C");
        PageInfoDto info = result.getPage();
        assertThat(info.getNumber()).isEqualTo(2);
        assertThat(info.getSize()).isEqualTo(10);
        assertThat(info.getTotalElements()).isEqualTo(53);
        assertThat(info.getTotalPages()).isEqualTo(6);
    }

    @Test
    void fromPage_emptyPage_returnsEmptyContent() {
        Page<String> page = new PageImpl<>(Collections.emptyList(), PageRequest.of(0, 20), 0);

        PageDataDto<String> result = PageDataFactory.fromPage(page);

        assertThat(result.getContent()).isEmpty();
        assertThat(result.getPage().getNumber()).isZero();
        assertThat(result.getPage().getTotalElements()).isZero();
        assertThat(result.getPage().getTotalPages()).isZero();
    }

    @Test
    void fromPage_singlePage_totalPagesIsOne() {
        Page<Integer> page = new PageImpl<>(List.of(1, 2), PageRequest.of(0, 5), 2);

        PageDataDto<Integer> result = PageDataFactory.fromPage(page);

        assertThat(result.getContent()).hasSize(2);
        assertThat(result.getPage().getTotalPages()).isEqualTo(1);
    }

    @Test
    void fromList_wrapsContentAsSinglePage() {
        List<String> items = List.of("X", "Y");

        PageDataDto<String> result = PageDataFactory.fromList(items);

        assertThat(result.getContent()).containsExactly("X", "Y");
        PageInfoDto info = result.getPage();
        assertThat(info.getNumber()).isZero();
        assertThat(info.getSize()).isEqualTo(2);
        assertThat(info.getTotalElements()).isEqualTo(2);
        assertThat(info.getTotalPages()).isEqualTo(1);
    }

    @Test
    void fromList_emptyList_returnsZeroMetrics() {
        PageDataDto<Object> result = PageDataFactory.fromList(Collections.emptyList());

        assertThat(result.getContent()).isEmpty();
        assertThat(result.getPage().getSize()).isZero();
        assertThat(result.getPage().getTotalElements()).isZero();
        assertThat(result.getPage().getTotalPages()).isEqualTo(1);
    }
}
