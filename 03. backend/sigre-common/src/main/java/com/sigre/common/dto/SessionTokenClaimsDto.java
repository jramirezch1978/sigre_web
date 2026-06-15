package com.sigre.common.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;
import java.util.Map;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SessionTokenClaimsDto {
    private String subject;
    private Long userId;
    private Long empresaId;
    private Long sucursalId;
    private Long tokensSessionId;
    private Boolean temporal;
    private Date issuedAt;
    private Date expiresAt;
    private Map<String, Object> claims;
}
