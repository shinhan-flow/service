package com.ssafy.shinhanflow.entity;

import java.time.LocalDateTime;

import org.hibernate.annotations.ColumnDefault;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "actions")
@Entity
public class ActionEntity {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@NotNull
	@Column(name = "member_id")
	private Long memberId;

	@NotNull
	@Column(name = "flow_id")
	private Long flowId;

	@NotNull
	@Column(name = "code")
	private int code;

	@NotNull
	@Column(name = "data")
	private String data;

	@ColumnDefault("CURRENT_TIMESTAMP")
	@Column(name = "created_at", nullable = false, insertable = false, updatable = false, columnDefinition = "TIMESTAMP")
	private LocalDateTime createdAt;

	@ColumnDefault("CURRENT_TIMESTAMP")
	@Column(name = "updated_at", nullable = false, insertable = false, columnDefinition = "TIMESTAMP")
	private LocalDateTime updatedAt;

	@ColumnDefault("NULL")
	@Column(name = "deleted_at", insertable = false, columnDefinition = "TIMESTAMP")
	private LocalDateTime deletedAt;

	public enum Category {
		NOTIFICATION, TRANSFER , EXCHANGE
	}

	public ActionEntity(Long memberId, Long flowId , int code, String data) {
		this.memberId = memberId;
		this.flowId = flowId;
		this.code = code;
		this.data = data;
	}
}
