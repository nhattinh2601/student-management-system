package vn.iotstar.service.impl;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import vn.iotstar.entity.Video;
import vn.iotstar.repository.VideoRepository;
import vn.iotstar.service.IVideoService;

@Service
public class VideoServiceImpl implements IVideoService{
	
	@Autowired
	VideoRepository videoRepository;

	public VideoServiceImpl(VideoRepository videoRepository) {		
		this.videoRepository = videoRepository;
	}

	@Override
	public List<Video> findByTitleContaining(String name) {
		return videoRepository.findByTitleContaining(name);
	}

	@Override
	public Page<Video> findByTitleContaining(String name, Pageable pageable) {
		return videoRepository.findByTitleContaining(name, pageable);
	}

	@Override
	public <S extends Video> S save(S entity) {
		if(entity.getVideoId() == null) {
			UUID uuid = UUID.randomUUID();
			String uuString = uuid.toString();
			entity.setVideoId(uuString);	
			
			return videoRepository.save(entity);
		}else {
			// kt su ton tai cua poster
			Optional<Video> opt = findById(entity.getVideoId());
			if(opt.isPresent()) {
				if(StringUtils.isEmpty(entity.getPoster())) {
					entity.setPoster(opt.get().getPoster());
				}else {
					entity.setPoster(entity.getPoster());
				}
			}
		}
		
		return videoRepository.save(entity);
	}

	@Override
	public List<Video> findAll() {
		return videoRepository.findAll();
	}

	@Override
	public Page<Video> findAll(Pageable pageable) {
		return videoRepository.findAll(pageable);
	}

	@Override
	public List<Video> findAll(Sort sort) {
		return videoRepository.findAll(sort);
	}

	@Override
	public List<Video> findAllById(Iterable<String> ids) {
		return videoRepository.findAllById(ids);
	}

	@Override
	public long count() {
		return videoRepository.count();
	}

	@Override
	public void deleteById(String id) {
		videoRepository.deleteById(id);
	}

	@Override
	public void delete(Video entity) {
		videoRepository.delete(entity);
	}
	

	@Override
	public Optional<Video> findById(String id) {
		return videoRepository.findById(id);
	}

	@Override
	public void deleteAll() {
		videoRepository.deleteAll();
	}
	
}
