package vn.iotstar.service.impl;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import vn.iotstar.entity.Category;
import vn.iotstar.repository.CategoryRepository;
import vn.iotstar.service.ICategoryService;

@Service
public class CategoryServiceImpl implements ICategoryService{
	
//	Dung de tim vao
	@Autowired
	CategoryRepository categoryRepository;

public CategoryServiceImpl(CategoryRepository categoryRepository) {	
	this.categoryRepository = categoryRepository;
}

@Override
public <S extends Category> S save(S entity) {
	return categoryRepository.save(entity);
}

@Override
public List<Category> findAll() {
	return categoryRepository.findAll();
}

@Override
public Page<Category> findAll(Pageable pageable) {
	return categoryRepository.findAll(pageable);
}

@Override
public List<Category> findAll(Sort sort) {
	return categoryRepository.findAll(sort);
}

@Override
public List<Category> findAllById(Iterable<Long> ids) {
	return categoryRepository.findAllById(ids);
}

@Override
public Optional<Category> findById(Long id) {
	return categoryRepository.findById(id);
}

@Override
public long count() {
	return categoryRepository.count();
}

@Override
public void deleteById(Long id) {
	categoryRepository.deleteById(id);
}

@Override
public void delete(Category entity) {
	categoryRepository.delete(entity);
}

@Override
public void deleteAll() {
	categoryRepository.deleteAll();
}

@Override
public List<Category> findByCategorynameContaining(String name) {
	// TODO Auto-generated method stub
	return categoryRepository.findByCategorynameContaining(name);
}

@Override
public Page<Category> findByCategorynameContaining(String name, Pageable pageable) {
	// TODO Auto-generated method stub
	return categoryRepository.findByCategorynameContaining(name, pageable);
}
	
}
