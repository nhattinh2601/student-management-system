package vn.iotstar.model;

import org.springframework.web.multipart.MultipartFile;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@NoArgsConstructor
@AllArgsConstructor
public class VideoModel {
	
	private String videoId;
	private boolean active;
	private String description;
	private MultipartFile imageFile;
	private String poster;
	private String title;
	private int views;
	
	private Long categoryId;
	
	private Boolean isEdit = false;
	private Boolean isSource = false;
}
