package vn.iotstar.service;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import vn.iotstar.entity.Video;


public interface IVideoService {

	void deleteAll();

	
	void delete(Video entity);

	void deleteById(String id);

	long count();

	List<Video> findAllById(Iterable<String> ids);

	List<Video> findAll(Sort sort);

	Page<Video> findAll(Pageable pageable);

	List<Video> findAll();

	<S extends Video> S save(S entity);

	Page<Video> findByTitleContaining(String name, Pageable pageable);

	List<Video> findByTitleContaining(String name);


	Optional<Video> findById(String id);

}
